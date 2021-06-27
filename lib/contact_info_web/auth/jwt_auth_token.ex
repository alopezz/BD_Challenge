defmodule ContactInfoWeb.JwtAuthToken do
  def decode(jwt_string) do
   Joken.verify(jwt_string, signer())
  end

  defp signer() do
    signer_config = [
      signer_alg: "RS256",
      key_pem: """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2osnYa7m59V5TSCFURXOdtjGP8CEZdMZ5ptN1ZEN8mwPhi1sfhR9XGlfsl6YjkGlaz2yBreJ4q/sTL6yARea9z7iZOoMzDXj/nAWWEUuI5TJ/vkNMprUMjBd+XfH2hBDCQM3l+9sq6Ovthoxb9/2pfTmuc+k30XR41GBv3F694KSNrpDtbQABRYJNsuU2QMP1xgPst7ceBvShQic4a8sW+c8xuDO8LUvPudVG7z/Azvzj4nJjsfAkCCUpTKLJmDhWu22TMYxWY/zussxjurdUMptQuNDYP/QrIStJsZokvCBgtHvTgZ/rCw5oe3XYhxXEOfO0qTKKt/D8yf9faRRzwIDAQAB
-----END PUBLIC KEY-----
"""
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
