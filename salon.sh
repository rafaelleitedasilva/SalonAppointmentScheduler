#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~ MY SALON ~~\n"
echo -e "Welcome to My Salon, how can I help you?"

GET_APPOINTMENT(){
  echo "What time would you like your service, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

GET_PHONE(){
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    GET_APPOINTMENT
  else
    GET_APPOINTMENT
  fi
}


QUESTIONS(){
  while IFS='|' read -r service_id name; do
        # Faça algo com cada nome (substitua o echo por sua lógica)
        echo "$service_id) $name"
  done <<< "$($PSQL "SELECT service_id, name FROM services;")"

  read SERVICE_ID_SELECTED

  SERVICE=$($PSQL "SELECT * FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SERVICE ]]
  then
    echo "I could not find that service. What would you like today?"
    QUESTIONS
  else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    GET_PHONE
  fi
}

QUESTIONS
