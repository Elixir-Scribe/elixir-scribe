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

    echo "Setup the new app with Elixir Scribe. Add database files to a folder ignored by git."

    exit 0
  fi
}

Scribe_Domain_Resource_Behaviour() {
  Maybe_Create_App

  mix scribe.gen.html ShoppingCart Orders order items:array:string --no-default-actions --actions place_order,cancel_order
  mix scribe.gen.html Accounting Invoices invoice items:array:string --no-default-actions --actions pay_invoice,cancel_invoice
}

Scribe_Domain_Criteria_1() {
  Maybe_Create_App

  mix scribe.gen.domain Sales.Catalog Category categories name:string desc:string
}

Scribe_Domain_Criteria_2() {
  Maybe_Create_App

  mix scribe.gen.domain Sales.Catalog Product products sku:string name:string desc:string --actions import,export
}

Scribe_Domain_Criteria_3() {
  Maybe_Create_App

  mix scribe.gen.html Warehouse.Fulfillment FulfillmentOrder fulfillment_orders uuid:string label:string total_quantity:integer location:string products_sku:array:string --no-default-actions --actions list
}

Scribe_Html_Criteria_1() {
  Maybe_Create_App

  mix scribe.gen.html Sales.Catalog Category categories name:string desc:string
}

Scribe_Html_Criteria_2() {
  Maybe_Create_App

  mix scribe.gen.html Sales.Catalog Product products sku:string name:string desc:string --actions import,export
}

Scribe_Html_Criteria_3() {
  Maybe_Create_App

  mix scribe.gen.html Warehouse.Fulfillment FulfillmentOrder fulfillment_orders uuid:string label:string total_quantity:integer location:string products_sku:array:string --no-default-actions --actions list
}

Todo_App() {
  Maybe_Create_App

  # mix scribe.gen.html Todo Task tasks title:string done:boolean --no-schema
  # mix scribe.gen.html Todo Tag tags title:string desc:string
  mix scribe.gen.html Accounts User users name:string email:string
  mix scribe.gen.html Accounts Admin admins name:string email:string --actions add_admin,modify_admin_account
}

Shop_App() {
  Maybe_Create_App

  # Sales Catalog
  mix scribe.gen.html Sales.Catalog Category categories name:string desc:string
  mix scribe.gen.html Sales.Catalog Product products sku:string name:string desc:string price:integer vat:integer --actions import,export
  mix scribe.gen.html Sales.Catalog Cart carts total_amount:integer total_quantity:integer products_skus:array:string --actions report

  # Sales Checkout
  mix scribe.gen.domain Sales.Checkout CheckoutProduct checkout_products sku:string name:string desc:string --no-default-actions --actions build
  mix scribe.gen.html Sales.Checkout Order orders total_amount:integer total_quantity:integer products_skus:array:string cart_uuid:string shipping_uuid:string --actions report

  # Sales Billing
  mix scribe.gen.domain Sales.Billing BillingProduct billing_products sku:string quantity:integer cost_per_unit:integer --no-default-actions --actions build

  # Warehouse Fulfillment
  mix scribe.gen.html Warehouse.Fulfillment FulfillmentProduct fulfillment_products sku:string label:string total_quantity:integer location:string --no-default-actions --actions build
  mix scribe.gen.html Warehouse.Shipment Parcel parcels pickup_datetime:datetime label:string carrier_uuid:string
}


Main() {
  export MIX_ENV=dev

  local APP_DIRNAME="my_app"
  local TARGET_DIR=".local"

  for input in "${@}"; do
    case "${input}" in
      --dir )
        shift 1
        TARGET_DIR="${1}"
        ;;

      app-todo )
        Todo_App
        exit $?
        ;;

      app-shop )
        Shop_App
        exit $?
        ;;

      behaviours )
        Scribe_Domain_Resource_Behaviour
        exit $?
        ;;

      scribe-domain-criteria-1 )
        Maybe_Create_App
        Scribe_Domain_Criteria_1
        exit $?
        ;;

      scribe-domain-criteria-2 )
        Maybe_Create_App
        Scribe_Domain_Criteria_2
        exit $?
        ;;

      scribe-domain-criteria-3 )
        Maybe_Create_App
        Scribe_Domain_Criteria_3
        exit $?
        ;;

      scribe-domain-criterias )
        Maybe_Create_App
        Scribe_Domain_Criteria_1
        Scribe_Domain_Criteria_2
        Scribe_Domain_Criteria_3
        exit $?
        ;;

      scribe-html-criteria-1 )
        Maybe_Create_App
        Scribe_Html_Criteria_1
        exit $?
        ;;

      scribe-html-criteria-2 )
        Maybe_Create_App
        Scribe_Html_Criteria_2
        exit $?
        ;;

      scribe-html-criteria-3 )
        Maybe_Create_App
        Scribe_Html_Criteria_3
        exit $?
        ;;

      scribe-html-criterias )
        Maybe_Create_App
        Scribe_Html_Criteria_1
        Scribe_Html_Criteria_2
        Scribe_Html_Criteria_3
        exit $?
        ;;
    esac
  done
}

Main "${@}"
