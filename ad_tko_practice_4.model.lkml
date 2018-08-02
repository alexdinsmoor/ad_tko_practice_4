connection: "video_store"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

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
    relationship: many_to_one #because one inventory can be shared across multiple rental ids
  }
}
