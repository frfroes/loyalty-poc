# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LoyaltyApi.Repo.insert!(%LoyaltyApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LoyaltyApi.Repo
alias LoyaltyApi.Accounts
alias LoyaltyApi.Loyalty

brand = Repo.insert!(%Accounts.Brand{name: "Westeros Entertainment Inc"})

Repo.insert!(%Accounts.Customer{
  name: "Jon Snow",
  email: "jon@thewall.com",
  phone_number: "+42 9898899",
  language: "en",
  brand_id: brand.id
})

Repo.insert!(%Loyalty.Points{
  amount: 42,
  code: "VALID6789",
  expiration_date: ~U[2077-10-31 19:59:00Z],
  redeemed: false
})

Repo.insert!(%Loyalty.Points{
  amount: 90,
  code: "USED56789",
  expiration_date: ~U[2077-10-31 19:59:00Z],
  redeemed: true
})

Repo.insert!(%Loyalty.Points{
  amount: 90,
  code: "EXPIRED89",
  expiration_date: ~U[2012-10-31 19:59:00Z],
  redeemed: false
})

Repo.insert!(%Loyalty.Coupon{
  cost: 65,
  description: "15% off on a trip to the ruins of old Valyria!"
})

Repo.insert!(%Loyalty.Coupon{
  cost: 20,
  description: "A free horseback riding lesson with a Dothraki"
})
