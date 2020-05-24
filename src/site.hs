--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Hakyll.Web.Sass (sassCompiler)
--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith configuration $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["keybase.txt", "williamwolf.asc"]) $ do
        route   idRoute
        compile copyFileCompiler

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx <> bodyField "description"

            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
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

    match (fromList ["index.md", "reading.html"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "posts/*/*" $ do
        route idRoute
        compile copyFileCompiler

    match "writing.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx
                    = listField "posts" postCtx (return posts)
                    <> defaultContext

            getResourceBody
                >>= applyAsTemplate archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx
    = dateField "date" "%d %b %Y"
    <> dateField "year" "%Y"
    <> defaultContext

configuration :: Configuration
configuration = defaultConfiguration
    { destinationDirectory = "../output/"
    , storeDirectory = "../.hakyll-cache"
    }

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = "willwolf.me"
    , feedDescription = "My little home on the web."
    , feedAuthorName = "William Wolf"
    , feedAuthorEmail = "will r wolf at gmail dot com"
    , feedRoot = "http://willwolf.me"
    }
