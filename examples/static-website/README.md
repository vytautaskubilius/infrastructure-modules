# Static website example

This is an example that demonstrates the usage of the `static-website` module by deploying the module, and uploading
an `index.html` file that returns an `OK` response when loaded.

## Usage

Refer to the `main.tf` and `vars.tf` files for details on what variables are expected to be supplied when running the
configuration. 

The example can easily be used for deploying a complete static website - simply replace the variables with ones that
reference your own domain and Route53 hosted zone, and change the supplied `index.html` file to something more complete.
Alternatively, the S3 upload portion can be removed altogether, and a different method of populating the created S3
buckets can be used to host your website.