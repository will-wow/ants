const path = require("path");

module.exports = {
  entry: ["whatwg-fetch", "./lib/js/src/components/MainComponent.bs.js"],
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          {
            loader: "style-loader" // creates style nodes from JS strings
          },
          {
            loader: "css-loader" // translates CSS into CommonJS
          },
          {
            loader: "sass-loader" // compiles Sass to CSS
          }
        ]
      }
    ]
  },
  output: {
    path: path.join(__dirname, "../priv/static/js"),
    filename: "index.js"
  }
};
