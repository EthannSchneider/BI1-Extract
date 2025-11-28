require 'json'
require_relative '../config'

# TODO: Auto-generate this file from the actual endpoints
get '/swagger.json' do
  content_type :json
  {
    openapi: "3.0.1",
    info: {
      title: "Extract API",
      version: "1.0.0",
      description: "Auto-generated swagger for the objects endpoint"
    },
    servers: [
      { url: PREFIX }
    ],
    paths: {
      "/objects" => {
        get: {
          summary: "List objects",
          tags: ["objects"],
          responses: {
            "200" => {
              description: "Array of object names",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: { type: "string" }
                  }
                }
              }
            }
          }
        }
      }
    }
  }.to_json
end

get '/docs/?' do
  content_type :html
  <<~HTML
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8"/>
        <title>API Docs</title>
        <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4/swagger-ui.css">
      </head>
      <body>
        <div id="swagger-ui"></div>
        <script src="https://unpkg.com/swagger-ui-dist@4/swagger-ui-bundle.js"></script>
        <script>
          window.ui = SwaggerUIBundle({
            url: '/swagger.json',
            dom_id: '#swagger-ui',
            deepLinking: true
          });
        </script>
      </body>
    </html>
  HTML
end