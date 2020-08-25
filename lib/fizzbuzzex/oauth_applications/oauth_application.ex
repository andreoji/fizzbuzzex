defmodule Fizzbuzzex.OauthApplications.OauthApplication do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :fizzbuzzex

  schema "oauth_applications" do
    application_fields()

    timestamps()
  end
end
