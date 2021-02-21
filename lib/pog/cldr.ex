defmodule Pog.Cldr do
  use Cldr,
    locales: Gettext.known_locales(PogWeb.Gettext),
    default_locale: "en",
    otp_app: :pog,
    providers: [Cldr.Number, Cldr.DateTime, Cldr.Calendar]
end
