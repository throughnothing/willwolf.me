const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/*.asc");
  eleventyConfig.addPassthroughCopy("src/*.txt");

  eleventyConfig.addPlugin(syntaxHighlight);
};