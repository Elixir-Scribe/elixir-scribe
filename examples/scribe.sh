#!/bin/sh

set -eu

Maybe_Create_App() {
  local _app_dir="${TARGET_DIR}/${APP_DIRNAME}"

  if [ -d "${_app_dir}" ]; then
    cd "${_app_dir}"
    git stash -u
  else
    mkdir -p "${TARGET_DIR}"
    cd "${TARGET_DIR}"
    mix phx.new "${APP_DIRNAME}" --database sqlite3

    echo "-> Add the Elixir Scribe dependency."
    echo "-> Run mix deps.get."
    echo "-> Run mix compile."
    echo "-> Run mix ecto.setup."
    echo "-> Run git init and commit it all."
    echo "-> You can now use ./examples/.scribe.sh example-here"

    exit 0
  fi
}

Todo_App() {
  # sleep .5 is required to ensure each migration has a different datetime

  mix scribe.gen.html Todo Task tasks title:string done:boolean --no-schema
  sleep .5

  mix scribe.gen.html Todo Tag tags title:string desc:string
  sleep .5

  mix scribe.gen.html Acounts User users name:string email:string
}

Shop_App() {
  # sleep .5 is required to ensure each migration has a different datetime

  # Sales Catalog
  mix scribe.gen.html Sales.Catalog Category categories name:string desc:string
  sleep .5

  mix scribe.gen.html Sales.Catalog Product products sku:string name:string desc:string price:integer vat:integer --actions import,export
  sleep .5

  mix scribe.gen.html Sales.Catalog Cart carts total_amount:integer total_quantity:integer products_skus:array:string --actions report
  sleep .5

  # Sales Checkout
  mix scribe.gen.domain Sales.Checkout CheckoutProduct checkout_products sku:string name:string desc:string --no-default-actions --actions build
  sleep .5

  mix scribe.gen.html Sales.Checkout Order orders total_amount:integer total_quantity:integer products_skus:array:string cart_uuid:string shipping_uuid:string --actions report
  sleep .5

  # Warehouse Fulfillment
  mix scribe.gen.html Warehouse.Fulfillment FulfillmentProduct fulfillment_products sku:string label:string total_quantity:integer location:string --no-default-actions --actions build
  sleep .5

  mix scribe.gen.html Warehouse.Shipment Parcel parcels pickup_datetime:datetime label:string carrier_uuid:string
}

Main() {
  export MIX_ENV=dev

  local APP_DIRNAME="my_app"
  local TARGET_DIR=".local"

  Maybe_Create_App

  for input in "${@}"; do
    case "${input}" in
      --dir )
        shift 1
        TARGET_DIR="${1}"
        ;;

      todo )
        Todo_App
        exit $?
        ;;

      shop )
        Shop_App
        exit $?
        ;;
    esac
  done
}

Main "${@}"
