# README

![](public/screenshot_12.png)

```
Author  : Roberto Nogueira
Date    : 2024-11
Project : Order Normalizer API
```

Author profile can be accessed in [LinkedIn](https://www.linkedin.com/in/enogrob/), and the Repo was created in 
[Github](https://github.com/enogrob/order_normalizer_api). 
See if required the 
[Luizalabs](https://www.linkedin.com/company/luizalabs/posts/?feedView=all) job 
[Job Description](https://www.linkedin.com/jobs/search/?currentJobId=4071757766&f_C=10435733&geoId=92000000&origin=COMPANY_PAGE_JOBS_CLUSTER_EXPANSION&originToLandingJobPostings=4083026839%2C4071757766%2C4084141403%2C4077188554%2C4083348762%2C4083025603%2C4083029211%2C4083029455%2C4083022862)

---

The `order_normalizer_api` is a Ruby on Rails REST API designed to process and normalize legacy data files. 
It accepts legacy files as input, normalizes and they are returned. As it supports background jobs processing, i.e. the system is able to enqueuing and retrieving them when required.
The API supports order querying with filters for order ID and purchase date ranges, ensuring robust functionality through adherence to SOLID design principles.

## Architecture Diagram

```mermaid
graph TD
    subgraph Client
        A[User]
    end

    subgraph Server
        B[OrdersController]
        C[NormalizeFileService]
        D[User Model]
        E[Order Model]
        F[Product Model]
    end

    subgraph Database
        G[(Users Table)]
        H[(Orders Table)]
        I[(Products Table)]
    end

    A --> |Uploads File| B
    B --> |Calls| C
    C --> |Finds or Creates| D
    C --> |Finds or Creates| E
    C --> |Creates| F
    D --> G
    E --> H
    F --> I
    B --> |Returns JSON| A
```    

This diagram shows the flow of data from the user uploading a file to the server processing it and interacting with the database, and finally returning a JSON response to the user. 

```mermaid
graph TD
    subgraph Models relationships
      A[User]
      B[Order]
      C[Product]
      E[Upload]
      D[ApplicationRecord]
      
      A -->|has_many| B
      B --> |belongs_to| A
      B --> |has_many| C
      C -->|belongs_to| B
      A --> |is_a| D
      B --> |is_a| D
      C --> |is_a| D
      E --> |is_a| D
    end
```

Here there is the Models relationships diagram.

This project adheres to SOLID principles, ensuring robustness, scalability, and maintainability.



## System dependencies

- [Asdf](https://asdf-vm.com), [Ruby](https://www.ruby-lang.org/en/news/2024/11/05/ruby-3-3-6-released/), [Rails](https://rubyonrails.org/) and [Nodejs](https://nodejs.org/en).
```shell
brew install asdf
echo ". /usr/local/opt/asdf/libexec/asdf.sh" >> $HOME/.zshrc
source $HOME/.zshrc
asdf plugin add ruby
asdf plugin add nodejs
asdf install ruby 3.3.6
asdf install nodejs 23.2.0
asdf global ruby 3.3.6
asdf global nodejs 23.2.0
gem install rails -v '8.0.0'
```
- [Jq](https://jqlang.github.io/jq) Lightweight and flexible command-line JSON processor.
```shell
brew install jq
```
- [Fly.io]() and [Docker](https://www.docker.com/products/docker-desktop).
```shell
brew install flyctl
curl -L https://fly.io/install.sh | sh
echo "export FLYCTL_INSTALL=/Users/enogrob/.fly" >> $HOME/.zshrc
echo "export PATH=\$FLYCTL_INSTALL/bin:\$PATH" >> $HOME/.zshrc
brew install --cask docker
source $HOME/.zshrc
``` 
- [Redis](https://redis.io/) Persistent key-value database, with built-in net interface
```
brew install redis
brew services start redis
brew services list
```

## Configuration
```shell 
git clone git@github.com:enogrob/order_normalizer_api.git
cd order_normalize_api
```

```shell
rails db:migrate
```

```shell
bundle
```
```shell
:
Bundle complete! 19 Gemfile dependencies, 115 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

### How to run the test suite

Run your tests  using rspec. 
```shell
bundle exec rspec
```
```shell
:
OrdersController
  POST #upload
    with valid file
      enqueues a file processing job
    with invalid file
      returns an error
    with empty file
      returns an error
  GET #index
    returns a list of orders
    filters orders by id
    filters orders by date range

NormalizeFileService
  .process
    with valid file
      processes the file successfully
    with invalid file
      raises InvalidFileFormatError
    with empty file
      raises InvalidFileFormatError

Finished in 0.67809 seconds (files took 4.04 seconds to load)
9 examples, 0 failures

Coverage report generated for RSpec to /Volumes/data/enogrob/Things/Projects/job-luizalabs/src/order_normalizer_api/coverage.
Line Coverage: 77.48% (86 / 111)
```

`SimpleCov` will generate a coverage report in the coverage directory.
Open the `index.html` file in the coverage directory in your browser to view the test coverage report.
```shell
open coverage/index.html
```
```shell
:
All Files ( 73.96% covered at 1.54 hits/line )
12 files in total.
96 relevant lines, 71 lines covered and 25 lines missed. ( 73.96% )
Search:
File	                                      % covered	 Lines	Relevant Lines	Lines covered	Lines missed	Avg. Hits / Line
app/mailers/application_mailer.rb	             0.00 %	     4	             4	            0	           4	            0.00
app/workers/file_upload_worker.rb	            23.08 %	    22	            13	            3	          10	            0.23
app/controllers/orders_controller.rb	        66.67 %	    73	            33	            22	          11	            1.61
app/controllers/application_controller.rb	   100.00 %	     2	             1	            1	           0	            1.00
app/errors/invalid_file_format_error.rb	     100.00 %	     5	             3	            3	           0	            1.33
app/jobs/application_job.rb	                 100.00 %	     7	             1	            1	           0	            1.00
app/models/application_record.rb	           100.00 %	     3	             2	            2	           0	            1.00
app/models/order.rb	                         100.00 %	     6	             4	            4	           0	            1.00
app/models/product.rb	                       100.00 %	     3	             2	            2	           0	            1.00
app/models/upload.rb	                       100.00 %	     5	             3	            3	           0	            1.00
app/models/user.rb	                         100.00 %	     3	             2	            2	           0	            1.00
app/services/normalize_file_service.rb	     100.00 %	    53	            28	           28	           0	            2.61
```

### How to run with API Endpoints
Start Ruby on Rails in one Terminal:
```shell
bin/dev
```
```shell
:
=> Booting Puma
=> Rails 8.0.0 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 6.5.0 ("Sky's Version")
* Ruby version: ruby 3.3.6 (2024-11-05 revision 75015d4c1f) [x86_64-darwin23]
*  Min threads: 3
*  Max threads: 3
*  Environment: development
*          PID: 8300
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

Start Sidekiq in other Terminal:
Note:
When running locally
```shell
bundle exec sidekiq
```
```shell


               m,
               `$b
          .ss,  $$:         .,d$
          `$$P,d$P'    .,md$P"'
           ,$$$$$b/md$$$P^'
         .d$$$$$$/$$$P'
         $$^' `"/$$$'       ____  _     _      _    _
         $:    ',$$:       / ___|(_) __| | ___| | _(_) __ _
         `b     :$$        \___ \| |/ _` |/ _ \ |/ / |/ _` |
                $$:         ___) | | (_| |  __/   <| | (_| |
                $$         |____/|_|\__,_|\___|_|\_\_|\__, |
              .d$$                                       |_|
      

2024-12-03T00:33:16.529Z pid=8560 tid=9uo INFO: Booted Rails 8.0.0 application in development environment
2024-12-03T00:33:16.529Z pid=8560 tid=9uo INFO: Running in ruby 3.3.6 (2024-11-05 revision 75015d4c1f) [x86_64-darwin23]
2024-12-03T00:33:16.529Z pid=8560 tid=9uo INFO: See LICENSE and the LGPL-3.0 for licensing details.
2024-12-03T00:33:16.530Z pid=8560 tid=9uo INFO: Upgrade to Sidekiq Pro for more features and support: https://sidekiq.org
2024-12-03T00:33:16.530Z pid=8560 tid=9uo INFO: Sidekiq 7.3.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/0"}
2024-12-03T00:33:16.564Z pid=8560 tid=9uo INFO: Sidekiq 7.3.6 connecting to Redis with options {:size=>5, :pool_name=>"default", :url=>"redis://localhost:6379/0"}
2024-12-03T00:33:16.667Z pid=8560 tid=9uo INFO: Starting processing, hit Ctrl-C to stop
```

Perform below in the other Terminal:
Note:
When running locally 
```shell
HOST_API=http://localhost:3000

```

When running the deployed
```shell
HOST_API=https://order-normalizer-api.fly.dev
```

Upload Order File
* URL: /orders/upload
* Method: POST
Params:
* file: The order file to be uploaded.
Response:
* 200 OK: File processing started
* 422 Unprocessable Entity: Error processing the file.
Examples:
```shell
curl -X POST -F "file=@data_1.txt" $HOST_API/orders/upload | jq '.'
```
```json
{
  "message": "File processing started",
  "upload_id": "24ceccff-860e-4e89-8c18-9237b287aba7"
}
```

```shell
curl -X POST -F "file=@data_2.txt" $HOST_API/orders/upload | jq '.'
```
```json
{
  "message": "File processing started",
  "upload_id": "c319265a-2a3c-4c79-8fcb-b79a5e7c7b55"
}
```

```shell
curl -X POST -F "file=@data_invalid.txt" $HOST_API/orders/upload | jq '.'
```
```json
{
  "error": "Error parsing line: 1234567890John Doe                         12345678901234567890123456789012345678901234567890123456789012345678901234567890\n. Error: invalid date"
}
```

```shell
curl -X POST -F "file=@data_empty.txt" $HOST_API/orders/upload | jq '.'
```
```json
{
  "error": "The file is empty."
}
```

Get Uploaded Order File Results
* URL: /orders/result
* Method: GET
Params:
* upload_id: The order uploaded file id.
Response:
* 200 OK: File is still processing
* 422 Upload not found
Examples:

```shell
curl -X GET "http://localhost:3000/orders/results?upload_id=24ceccff-860e-4e89-8c18-9237b287aba7" | jq '.'
```
```json
:
{
    "user_id": 62,
    "name": "Jonah Satterfield",
    "orders": [
      {
        "order_id": 673,
        "total": "851.01",
        "date": "2021-08-29",
        "products": [
          {
            "product_id": 3,
            "value": 851.01
          }
        ]
      }
    ]
  }
]
```

```shell
curl -X GET "http://localhost:3000/orders/results?upload_id=c319265a-2a3c-4c79-8fcb-b79a5e7c7b55" | jq '.'
```
```json
:
{
    "user_id": 199,
    "name": "Miss Terry Boyle",
    "orders": [
      {
        "order_id": 1829,
        "total": "1263.59",
        "date": "2021-06-25",
        "products": [
          {
            "product_id": 3,
            "value": 1263.59
          }
        ]
      }
    ]
  }
]
```

```shell
curl -X GET "http://localhost:3000/orders/results?upload_id=xxx" | jq '.'
```
```json
:
{
  "error": "Upload not found"
}
```

Error Handling
* If the uploaded file is empty, the API will return a 422 Unprocessable Entity status with the message "The file is empty."
* If there is an error parsing the file, the API will return a 422 Unprocessable Entity status with the error message.

List Orders
* URL: /orders
* Method: GET
Params:
* id (optional): Filter orders by ID.
* start_date (optional): Filter orders by start date.
* end_date (optional): Filter orders by end date.
Response:
* 200 OK: List of orders.
Examples:
```shell
curl "$HOST_API/orders?id=628" | jq '.'
```
```json
[
  {
    "order_id": 628,
    "total": "4132.24",
    "date": "2021-03-08",
    "products": [
      {
        "product_id": 4,
        "value": "1396.87"
      },
      {
        "product_id": 3,
        "value": "1940.89"
      },
      {
        "product_id": 4,
        "value": "794.48"
      }
    ]
  },
  {
    "order_id": 628,
    "total": "804.47",
    "date": "2021-09-11",
    "products": [
      {
        "product_id": 4,
        "value": "804.47"
      }
    ]
  }
]
```

```shell
curl "$HOST_API/orders?start_date=2021-01-01&end_date=2021-12-31" | jq '.'
```
```json
:
 {
    "order_id": 702,
    "total": "1419.69",
    "date": "2021-07-18",
    "products": [
      {
        "product_id": 2,
        "value": "1419.69"
      }
    ]
  },
  {
    "order_id": 1842,
    "total": "1382.56",
    "date": "2021-04-04",
    "products": [
      {
        "product_id": 4,
        "value": "1382.56"
      }
    ]
  }
]
```

### Services (job queues, cache servers, search engines, etc.)

This project uses Redis and Sidekiq for background job processing.

#### Redis:
- Redis is an in-memory data structure store, used as a database, cache, and message broker.
- In this project, Redis is used to store job data and manage job queues.

#### Sidekiq:
- Sidekiq is a background job processing library for Ruby.
- It uses threads to handle many jobs at the same time in the same process.
- Sidekiq relies on Redis to store all job-related data.
- In this project, Sidekiq is used to process background jobs, such as legacy files in order to be normalized.

### Deployment instructions

Deploying a Ruby on Rails app to [Fly.io](https://fly.io) involves using the [flyctl CLI](https://fly.io/docs/flyctl/install/) to initialize a project (also [Docker](https://www.docker.com/products/docker-desktop/) is required), generate a `fly.toml` file, containerize the app with Docker, and push it to [Fly.io](https://fly.io). Once deployed, the app goes live with provisioned resources. You can monitor logs, scale instances, and manage secrets with [Fly.io](https://fly.io) commands.

```mermaid
graph TD
    subgraph Fly.io Commands
        A[fly launch]
        B[fly deploy]
        M[fly status]
        D[fly logs]
        E[fly apps destroy order-normalizer-api]
        F[fly ssh console --pty -C '/rails/bin/rails console']
        G[fly ssh console --pty -C '/bin/bash']
        H[fly redis create]
        I[fly redis connect]
        J[fly ssh console -C '/rails/bin/rails db:migrate']
        K[bin/rails fly:console]
        L[fly ssh console -C 'printenv REDIS_URL']
        N[root]
        O[bin/rails fly:dbmigrate]

        B --> |repeat if changes occur| B
        B --> D
        B --> F
        B --> |if required| E
        E --> A
        B --> J
        B --> G
        H --> I
        F --> K
        H --> L
        H --> A
        A --> B
        N --> H
        N --> M
        J --> O
    end
```

This diagram captures the workflow and emphasizes the iterative nature of fly deploy if changes are made to the application.

## Git Graph

```mermaid
gitGraph
   commit id: "ruby-on-rails-setup"
   commit id: "models-setup"
   commit id: "services-setup"
   commit id: "controllers-setup"
   commit id: "tests-setup"
   commit id: "errors-handling-setup"
   commit id: "readme-setup"
   commit id: "solid-compliance-check"
   commit id: "readme-add-components-diagram"
   commit id: "readme-add-refinements"
   commit id: "test-coverage-and-test-files-setup"
   commit id: "readme-and-gitignore-improved"
   commit id: "deploy-setup" 
   commit id: "readme-improvements"
   commit id: "background-jobs-setup" type: HIGHLIGHT
```

## References

Here are some valuable resources for the technologies used in this project:

1. **Ruby on Rails**
   - [Official Ruby on Rails Guides](https://guides.rubyonrails.org/)
   - [Ruby on Rails API Documentation](https://api.rubyonrails.org/)
   - [RailsCasts](http://railscasts.com/)

2. **RSpec**
   - [Official RSpec Documentation](https://rspec.info/documentation/)
   - [Better Specs](http://www.betterspecs.org/)

3. **SimpleCov**
   - [SimpleCov GitHub Repository](https://github.com/simplecov-ruby/simplecov)
   - [SimpleCov Documentation](https://github.com/simplecov-ruby/simplecov#readme)

4. **Fly.io**
   - [Fly.io Documentation](https://fly.io/docs/)
   - [Fly.io GitHub Repository](https://github.com/superfly/flyctl)

5. **Docker**
   - [Docker Documentation](https://docs.docker.com/)
   - [Docker Hub](https://hub.docker.com/)

6. **Git**
   - [Pro Git Book](https://git-scm.com/book/en/v2)
   - [Git Documentation](https://git-scm.com/doc)

7. **Mermaid**
   - [Mermaid Documentation](https://mermaid.js.org/intro/)
   - [Mermaid Github Repository](https://github.com/mermaid-js/mermaid)

7. **Redis**
   - [Redis Documentation](https://redis.io/docs/latest/)
   - [Redis Github Repository](https://github.com/redis/redis)

7. **Sidekiq**
   - [Sidekiq Documentation](https://github.com/sidekiq/sidekiq/wiki)
   - [Sidekiq Github Repository](https://github.com/sidekiq/sidekiq)
