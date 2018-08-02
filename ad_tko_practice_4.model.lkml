connection: "video_store"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: caching_policy {
  max_cache_age: "24 hours"
#   sql_trigger: select max(rental_id) from sakil.rental ;;
}

persist_with: caching_policy

explore: rental_history_facts {}

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
