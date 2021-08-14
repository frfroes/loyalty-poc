# LoyaltyPoc

## Prerequisites

- Postgres 13 or higher running on port `5432`
- Elixir 1.11 or highther installed

## How to run

Run all commands from project's root
- `cd apps/blockchain && mix setup`
- `cod apps/loyalty_api && mix setup`
- `mix phx.server`

This will already populate the DB with some data you can use for the operations.

## Available endpoints

Remember that for loyalty endpoints you need to set the `authorization` header as `Bearer <customer_uid>`. You can find one at the `customers` table.

### `POST  /loyalty/points/redeem/:code`
Redeems a code for a user, the prepopulated ones are:

- *VALID6789*
- *USED56789*
- *EXPIRED89*

### `POST  /loyalty/coupon/claim/:uid`
Claims a coupon for the user, you can check available uids in the `coupons` table.

### `GET /loyalty/transactions`
Get the list of transactions of an user, you can check available uids in the `customers` table.

### `POST  /accounts/customer`
Creates a customer. It requires a `brand_id`, you can check available uids in the `brands` table.
Payload exemple:
```json
{
 	"email": "customer@email.com",
	"name": "person",
	"language": "en",
	"phone_number": "+356 5567",
	"brand_id": "3ab4a7a5-f97e-43d3-a508-ea56d185f083"
}
```

## Running tests

Just run `mix tests` from project's root

you can also check types with `mix dialyzer`. 
