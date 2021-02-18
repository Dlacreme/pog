defmodule Pog.Accounts.Profile do
  @enforce_keys [:user_id, :name, :title]
  defstruct user_id: nil,
            name: nil,
            title: nil,
            picture_url: "https://p1.hiclipart.com/preview/295/13/148/ed-sheeran-random-man-wearing-black-long-sleeved-shirt.jpg"

  @type t() :: %__MODULE__{
          user_id: String.t(),
          name: String.t(),
          title: String.t(),
          picture_url: String.t(),
        }
end
