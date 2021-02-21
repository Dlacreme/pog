defmodule Pog.RolesFixtures do
  alias Pog.Accounts.UserRole
  alias Pog.Repo

  def create_roles do
    Repo.insert!(
      %UserRole{
        id: "admin",
        label: "Admin"
      },
      on_conflict: :nothing
    )

    Repo.insert!(
      %UserRole{
        id: "employee",
        label: "Employee"
      },
      on_conflict: :nothing
    )

    Repo.insert!(
      %UserRole{
        id: "guest",
        label: "Guest"
      },
      on_conflict: :nothing
    )
  end
end
