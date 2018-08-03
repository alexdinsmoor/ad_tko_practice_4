connection: "video_store"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: caching_policy {
  max_cache_age: "24 hours"
#   sql_trigger: select max(rental_id) from sakil.rental ;;
}

persist_with: caching_policy

# aggregate store information

explore: store_information {
  from: store
  hidden: yes

  join: address {
    view_label: "Store Information"
    fields:[address.address, address.district, address.postal_code, address.phone]
    type: left_outer
    sql_on: ${store_information.address_id} = ${address.address_id} ;;
    relationship: one_to_one
  }

  join: city {
    view_label: "Store Information"
    fields: [city.city]
    type: left_outer
    sql_on: ${address.city_id} = ${city.city_id} ;;
    relationship: many_to_one
  }

  join: country {
    view_label: "Store Information"
    fields: [country.country]
    type: left_outer
    sql_on: ${city.country_id} = ${country.country_id} ;;
    relationship: many_to_one
  }
}

#aggregate customer information

explore: customer {
  label: "Customer Information"
  from: customer
  view_label: "Customer Contact Info"

  join: customer_address {
    from: address
    view_label: "Customer Contact Info"
    fields:[customer_address.address, customer_address.district, customer_address.postal_code, customer_address.phone ]
    type: left_outer
    sql_on: ${customer.address_id} = ${customer_address.address_id} ;;
    relationship: many_to_one
  }

  join: customer_city {
    from: city
    view_label: "Customer Contact Info"
    fields:[customer_city.city]
    type: left_outer
    sql_on: ${customer_address.city_id} = ${customer_city.city_id} ;;
    relationship: many_to_one
  }

  join: customer_country {
    from: country
    view_label: "Customer Contact Info"
    fields:[customer_country.country]
    type: left_outer
    sql_on: ${customer_city.country_id} = ${customer_country.country_id} ;;
    relationship: many_to_one
  }
}

explore: rental_information {
  from: rental
  sql_always_where: (${rental_date} >= '2005-05-01' and ${rental_date} <= '2005-08-31');;
  # added to ensure we evaluate complete only months with representative data

  join: payment {
    type: left_outer
    sql_on: ${rental_information.rental_id} = ${payment.rental_id} ;;
    relationship: one_to_one
  }

  join: inventory {
    type: left_outer
    sql_on: ${rental_information.inventory_id} = ${inventory.inventory_id} ;;
    relationship: many_to_one #because one inventory item can be shared across multiple rental ids
  }

  # aggregate customer information

  join: customer {
    view_label: "Customer Contact Info"
    type: left_outer
    sql_on: ${rental_information.customer_id} = ${customer.customer_id} ;;
    relationship: many_to_one
  }

  join: customer_address {
    from: address
    view_label: "Customer Contact Info"
    fields:[customer_address.address, customer_address.district, customer_address.postal_code, customer_address.phone ]
    type: left_outer
    sql_on: ${customer.address_id} = ${customer_address.address_id} ;;
    relationship: many_to_one
  }

  join: customer_city {
    from: city
    view_label: "Customer Contact Info"
    fields:[customer_city.city]
    type: left_outer
    sql_on: ${customer_address.city_id} = ${customer_city.city_id} ;;
    relationship: many_to_one
  }

  join: customer_country {
    from: country
    view_label: "Customer Contact Info"
    fields:[customer_country.country]
    type: left_outer
    sql_on: ${customer_city.country_id} = ${customer_country.country_id} ;;
    relationship: many_to_one
  }

  # aggregate store information

  join: store {
    type:  left_outer
    sql_on: ${inventory.store_id} = ${store.store_id}  ;;
    relationship: many_to_one
  }

  join: store_address {
    from: address
    view_label: "Store Information"
    fields:[store_address.address, store_address.district, store_address.postal_code, store_address.phone]
    type: left_outer
    sql_on: ${store.address_id} = ${store_address.address_id} ;;
    relationship: one_to_one
  }

  join: store_city {
    from: city
    view_label: "Store Information"
    fields: [store_city.city]
    type: left_outer
    sql_on: ${store_address.city_id} = ${store_city.city_id} ;;
    relationship: many_to_one
  }

  join: store_country {
    from: country
    view_label: "Store Information"
    fields: [store_country.country]
    type: left_outer
    sql_on: ${store_city.country_id} = ${store_country.country_id} ;;
    relationship: many_to_one
  }

  # aggregate film information



}

explore: inventory {
  view_label: "Inventory Information"
  # sql_always_where: (${rental_date} >= '2005-05-01' and ${rental_date} <= '2005-08-31');;
  # added to ensure we evaluate complete only months with representative data
  fields: [
     ALL_FIELDS*,
    -rental.avg_revenue_per_rental,
    -rental.revenue
  ]

  join: rental {
    type: left_outer
    sql_on: ${inventory.inventory_id} = ${rental.inventory_id} ;;
    relationship: one_to_many #because one inventory item can be shared across multiple rental ids
  }
}
