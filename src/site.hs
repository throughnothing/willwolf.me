--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad (liftM)
import           Data.Monoid (mappend)
import           Data.Text (replace, unpack, pack)
import           Hakyll
import           Hakyll.Web.Sass (sassCompiler)
import           System.FilePath ( (</>), (<.>)
                                 , splitExtension, splitFileName
                                 , takeDirectory )
import Control.Applicative (Alternative (..))
--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith configuration $ do
    let postsPattern = "posts/*.md"
        postsFilesPattern = "posts/*/*"

    match "images/*" $ route idRoute *> compile copyFileCompiler
    match "assets/*" $ route idRoute *> compile copyFileCompiler
    match "keybase.txt" $ route idRoute *> compile copyFileCompiler
    match "williamwolf.asc" $ route idRoute *> compile copyFileCompiler
    match "templates/*" $ compile templateBodyCompiler

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx <> bodyField "description"
            posts <- fmap (take 10) . recentFirst =<< loadAllSnapshots "posts/*" "content"
            renderRss feedConfiguration feedCtx posts

    -- Compile SASS
    match "css/*" $ do
        let compressCssItem = fmap compressCss
        compile (compressCssItem <$> sassCompiler)

    -- Combine all CSS
    create ["all.css"] $ do
        route idRoute
        compile $ do
            items <- loadAll "css/*" :: Compiler [Item String]
            makeItem $ concatMap itemBody items

    match "about.md" $ do
        route $ setExtension "html"
            `composeRoutes` appendIndex
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" dropIndexHtmlUrlContext
            >>= relativizeAllUrls

    match "tweets.html" $ do
        route $ idRoute `composeRoutes` appendIndex
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" dropIndexHtmlUrlContext
            >>= relativizeAllUrls

    match "reading.html" $ do
        route $ setExtension "html"
            `composeRoutes` appendIndex

        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" dropIndexHtmlUrlContext
            >>= relativizeAllUrls

    paginate <- buildPaginateWith postsGrouper postsPattern postsPageId
    tags <- buildTags postsPattern (fromCapture "archive/*/index.html")


    paginateRules paginate $ \page pattern -> do
        route $ idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots pattern "raw"
            let ctx = (paginateContext paginate page)
                    <> defaultContext
                    -- <> listField "posts" (field "content" (return . itemBody)) (return posts)
                    <> listField "posts" (postCtxWithTags tags) (return posts)
                    <> constField "title" (if page == 1 then "Home" else "Page " ++ show page)

            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/page.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeAllUrls

    tagsRules tags $ \tagStr tagsPattern -> do
        route $ idRoute
        compile $ do
            posts       <- recentFirst =<< loadAllSnapshots tagsPattern "raw" :: Compiler [Item String]
            let tagCtx = constField "title" tagStr
                        `mappend` constField "tag" tagStr    
                        `mappend` listField "posts" postCtx (return posts)
                        `mappend` defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" tagCtx
                >>= loadAndApplyTemplate "templates/default.html" tagCtx
                >>= relativizeAllUrls

    match "tags.html" $ do
        -- route $ constRoute "/archive/tags/index.html" 
        route $ idRoute `composeRoutes` appendIndex
        compile $ do
            let ctx = tagCloudField "tagCloud" 100 400 tags
                    <> defaultContext

            getResourceBody
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeAllUrls



    matchMetadata postsPattern (not . isDraft) $ do
        route $ setExtension "html"
            `composeRoutes` dateFolders
            `composeRoutes` dropPostsPrefix
            `composeRoutes` appendIndex

        compile $ do
            getResourceBody
                -- | Convert $ -> $$ and %%% -> $ in raw Markdown Body
                >>= preparePostTemplateStrings
                -- | Apply as template so template vars go to Markdown
                >>= applyAsTemplate postCtx
                -- | Then render the Pandoc
                >>= renderPandoc
                -- | Save a raw snapshot before goin through the template
                >>= saveSnapshot "raw"
                >>= loadAndApplyTemplate "templates/post.html" (postCtxWithTags tags)
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
                >>= relativizeAllUrls


                
    match postsFilesPattern $ do
        route $ idRoute
            `composeRoutes` dateFolders
            `composeRoutes` dropPostsPrefix
        compile copyFileCompiler

    match "archive.html" $ do
        route $ idRoute `composeRoutes` appendIndex
        compile $ do
            posts <- recentFirst =<< loadAll (postsPattern)
            let archiveCtx
                    = listField "posts" postCtx (return posts)
                    <> dropIndexHtmlUrlContext

            getResourceBody
                >>= applyAsTemplate archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeAllUrls

postsGrouper :: (MonadFail m, MonadMetadata m) => [Identifier] -> m [[Identifier]]
postsGrouper = liftM (paginateEvery 1) . sortRecentFirst

postsPageId :: PageNumber -> Identifier
postsPageId n = fromFilePath $ if (n == 1) then "index.html" else "Page/" ++ show n ++ "/index.html"

--------------------------------------------------------------------------------

-- | Replaces "$" with "$$" to avoid templating, and uses "%%%VAR%%%" as template
-- | replacing the "%%%" with a "$"
preparePostTemplateStrings :: Item String -> Compiler (Item String)
preparePostTemplateStrings = makeItem . unpack . replaceAll . pack . itemBody
    where
        replaceDollar = replace "$" "$$" 
        replaceCustomTemplateVar = replace "%%%" "$"
        replaceAll = replaceCustomTemplateVar . replaceDollar


postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags <> postCtx

postCtx :: Context String
postCtx
    = dateField "date" "%d %b %Y"
    <> dateField "year" "%Y"
    <> dropIndexHtmlUrlContext

configuration :: Configuration
configuration = defaultConfiguration
    { destinationDirectory = "../output/"
    , storeDirectory = "../.hakyll-cache"
    }

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = "willwolf.me"
    , feedDescription = "William Wolf's home on the web."
    , feedAuthorName = "William Wolf"
    , feedAuthorEmail = "throughnothing@gmail.com"
    , feedRoot = "http://willwolf.me"
    }


dropIndexHtmlUrlContext :: Context String
dropIndexHtmlUrlContext = dropIndexHtml "url" <> defaultContext


-- | With help from: 
-- | https://groups.google.com/forum/#!searchin/hakyll/withUrls%7Csort:date/hakyll/ohfcF7qoV8s/m92npAU8AgAJ
-- | This makes it so that in posts, we can just assume all
-- | assets in the post's folder are in the current directory
handlePostFileUrls :: Item String -> Compiler (Item String) 
handlePostFileUrls item = do
    getUnderlying
        >>= getRoute
        >>= maybe
            (return item)
            (\path -> return $ fmap (withUrls $ absolutize path) item)
    where 
        absolutize :: String -> String -> String 
        absolutize path url = case takeDirectory url of 
            "." -> "/" <> takeDirectory path <> "/" <> url
            _  -> url 

relativizeAllUrls :: Item String -> Compiler (Item String)
relativizeAllUrls item = relativizeUrls =<< handlePostFileUrls item

isDraft :: Metadata -> Bool
isDraft = maybe False (== "true") . lookupString "draft"


-- All the below was taken from:
-- https://github.com/aherrmann/jekyll_style_urls_with_hakyll_examples/blob/master/site.hs
-- https://aherrmann.github.io/programming/2016/01/31/jekyll-style-urls-with-hakyll/

dateFolders :: Routes
dateFolders =
    gsubRoute "/[0-9]{4}-[0-9]{2}-[0-9]{2}-" $ replaceAll "-" (const "/")

dropPostsPrefix :: Routes
dropPostsPrefix = gsubRoute "posts/" $ const ""

addDraftsPrefix :: Routes
addDraftsPrefix = gsubRoute "posts/" $ const "drafts/"

dropIndexHtml :: String -> Context a
dropIndexHtml key = mapContext transform (urlField key) where
    transform url = case splitFileName url of
                        (p, "index.html") -> takeDirectory p
                        _                 -> url

appendIndex :: Routes
appendIndex = customRoute $
    (\(p, e) -> p </> "index" <.> e) . splitExtension . toFilePath