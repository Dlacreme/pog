
Pog.Repo.insert!(%Pog.Accounts.UserRole{
  id: "admin",
  label: "Admin"
})
Pog.Repo.insert!(%Pog.Accounts.UserRole{
  id: "employee",
  label: "Employee"
})
Pog.Repo.insert!(%Pog.Accounts.UserRole{
  id: "guest",
  label: "Guest"
})

# Create a default account email: admin@pog.com | password: toto4242
Pog.Accounts.register_user(%{email: "admin@pog.com", password: "toto4242", role_id: "admin"})
