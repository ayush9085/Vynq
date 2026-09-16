import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    {
      name: 'api-waitlist-dev-plugin',
      configureServer(server) {
        server.middlewares.use('/api/waitlist', async (req, res, next) => {
          if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => { body += chunk; });
            req.on('end', async () => {
              try {
                const data = JSON.parse(body || '{}');
                const handler = (await import('./api/waitlist.js')).default;
                const fakeRes = {
                  setHeader: (key, val) => res.setHeader(key, val),
                  status: (code) => ({
                    json: (obj) => {
                      res.statusCode = code;
                      res.setHeader('Content-Type', 'application/json');
                      res.end(JSON.stringify(obj));
                    },
                    end: () => res.end()
                  })
                };
                await handler({ method: 'POST', body: data }, fakeRes);
              } catch (e) {
                res.statusCode = 500;
                res.end(JSON.stringify({ error: e.message }));
              }
            });
          } else if (req.method === 'GET') {
            try {
              const handler = (await import('./api/waitlist.js')).default;
              const fakeRes = {
                setHeader: (key, val) => res.setHeader(key, val),
                status: (code) => ({
                  json: (obj) => {
                    res.statusCode = code;
                    res.setHeader('Content-Type', 'application/json');
                    res.end(JSON.stringify(obj));
                  },
                  end: () => res.end()
                })
              };
              await handler({ method: 'GET' }, fakeRes);
            } catch (e) {
              res.statusCode = 500;
              res.end(JSON.stringify({ count: 2480 }));
            }
          } else {
            next();
          }
        });
      }
    }
  ],
  server: {
    port: 3000,
    host: true,
  },
});

