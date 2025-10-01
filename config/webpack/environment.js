const { environment } = require('@rails/webpacker')
const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: require.resolve('jquery'),
    jQuery: require.resolve('jquery'),
    Popper: ['popper.js', 'default']
  }))

environment.loaders.get('sass').use.forEach(loader => {
  if (loader.loader === 'postcss-loader') {
    delete loader.options.config
  }
})
module.exports = environment
