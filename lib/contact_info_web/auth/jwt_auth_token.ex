defmodule ContactInfoWeb.JwtAuthToken do
  def decode(jwt_string, public_pem) do
    Joken.verify_and_validate(%{}, jwt_string, signer(public_pem), nil, [CheckExpirationHook])
  end

  defp signer(public_pem) do
    signer_config = [
      signer_alg: "RS256",
      key_pem: public_pem
    ]

    %Joken.Signer{
      alg: signer_config[:signer_alg],
      jwk: signing_key(signer_config[:key_pem])
    }
  end

  defp signing_key(public_key_string) do
    JOSE.JWK.from_pem(String.trim(public_key_string))
  end
end

defmodule CheckExpirationHook do
  use Joken.Hooks

  @impl true
  def after_verify(_hook_options, result, input) do
    case result do
      {:error, :invalid_signature} ->
        {:halt, result}

      {:ok, claims} ->
        if claims["exp"] > Joken.current_time() do
          {:cont, result, input}
        else
          {:halt, :expired_token}
        end
    end
  end
end
