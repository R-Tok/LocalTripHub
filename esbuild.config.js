import esbuild from 'esbuild';
import vuePlugin from 'esbuild-plugin-vue';

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  plugins: [vuePlugin()],
}).catch(() => process.exit(1));
