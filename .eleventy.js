module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/*.css");
  eleventyConfig.addPassthroughCopy("src/*.asc");
  eleventyConfig.addPassthroughCopy("src/*.txt");
};