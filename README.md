# COVID-19 visualization

## Updating COVID-19 data

The data is included via git submodule. In order to update the data run the following command:

    git submodule update --remote

Note that this process is happening automatically on heroku while deploying.

## Development

    bundle exec rerun "rackup -p3000"
   
