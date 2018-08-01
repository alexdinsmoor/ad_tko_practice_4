connection: "video_store"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

explore: rental_information {
  from: rental
  join: payment {
    type: left_outer
    sql_on: ${rental_information.rental_id} = ${payment.rental_id} ;;
    relationship: one_to_one
  }
}
