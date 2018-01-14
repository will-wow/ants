const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: ["whatwg-fetch", "./index.js"],
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
  plugins: [new CopyWebpackPlugin([{ from: "static", to: ".." }])],
  output: {
    path: path.join(__dirname, "../priv/static/js"),
    filename: "index.js"
  }
};
