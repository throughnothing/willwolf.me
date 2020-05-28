--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Hakyll.Web.Sass (sassCompiler)
import           System.FilePath ( (</>), (<.>)
                                 , splitExtension, splitFileName
                                 , takeDirectory )
--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith configuration $ do
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

    match "index.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" dropIndexHtmlUrlContext
            >>= relativizeAllUrls

    match "reading.html" $ do
        route $ setExtension "html"
            `composeRoutes` appendIndex

        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" dropIndexHtmlUrlContext
            >>= relativizeAllUrls

    matchMetadata "posts/*.md" (not . isDraft) $ do
        route $ postsRoutes
        postsCompiler

    match "posts/*/*" $ do
        route $ idRoute
            `composeRoutes` dateFolders
            `composeRoutes` dropPostsPrefix
        compile copyFileCompiler

    match "writing.html" $ do
        route $ idRoute `composeRoutes` appendIndex
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*.md"
            let archiveCtx
                    = listField "posts" postCtx (return posts)
                    <> dropIndexHtmlUrlContext

            getResourceBody
                >>= applyAsTemplate archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeAllUrls


    where

    postsRoutes = setExtension "html"
        `composeRoutes` dateFolders
        `composeRoutes` dropPostsPrefix
        `composeRoutes` appendIndex

    postsCompiler = 
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeAllUrls
--------------------------------------------------------------------------------

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