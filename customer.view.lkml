view: customer {
  sql_table_name: sakila.customer ;;

  dimension: customer_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: address_id {
    type: number
    hidden: yes
    sql: ${TABLE}.address_id ;;
  }

  dimension_group: create {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.create_date ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    action: {
      label: "Email Reminder to Customer"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "Reminder: {{ film.film_title._value }} due on {{rental.expected_return_date._value}}"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
"Dear {{ customer.first_name._value }},

 Thanks for your loyalty to 2020 Video.  We'd like to remind you that your current rental is due
 on {{rental.expected_return_date._value}}.

 Your friends at 2020 Video"
      }
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_update {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_rental_facts.detail*]
  }
}
