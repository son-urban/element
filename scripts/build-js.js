/**
 * Build JS bundle using webpack API (avoids webpack CLI hanging issue)
 */
const webpack = require('webpack');
const mode = process.argv[2] || 'dev';
const configPath = mode === 'prod'
  ? '../build/webpack.conf.js'
  : '../build/webpack.conf.dev.js';

const config = require(configPath);

const compiler = webpack(config);
compiler.run((err, stats) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(stats.toString({
    colors: true,
    modules: false,
    children: false,
    chunks: false,
    chunkModules: false
  }));
  if (stats.hasErrors()) {
    process.exit(1);
  }
  process.exit(0);
});
