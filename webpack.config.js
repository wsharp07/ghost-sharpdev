var path = require('path');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

const extractSass = new ExtractTextPlugin("styles.min.css");

module.exports = {
    entry: "./webpack.entry.js",
    output: {
        path: path.join(__dirname, '/assets/dist'),
        filename: "bundle.js"
    },
    plugins: [
        extractSass
    ],
    module: {
        rules: [
            {
                test: /\.scss$/,
                exclude: /node_modules/,
                use: extractSass.extract({
                    use: [
                        {
                            loader: "css-loader", 
                            options: { minimize: true }
                        },
                        {
                            loader: "sass-loader"
                        }
                    ],
                    // use style-loader in development
                    fallback: "style-loader"
                })
            }
        ]
    }
}