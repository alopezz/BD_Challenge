defmodule ContactInfoWeb.JwtAuthToken do
  def decode(jwt_string, public_pem) do
   Joken.verify(jwt_string, signer(public_pem))
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
