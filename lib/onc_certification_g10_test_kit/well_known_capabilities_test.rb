module ONCCertificationG10TestKit
  class SMARTWellKnownCapabilitiesTest < Inferno::Test
    title 'Well-known configuration declares support for required capabilities'
    description %(
      A SMART on FHIR server SHALL convey its capabilities to app developers
      by listing the SMART core capabilities supported by their
      implementation within the Well-known configuration file. This test
      ensures that the capabilities required by this scenario are properly
      documented in the Well-known file.
    )
    id :g10_smart_well_known_capabilities
    input :well_known_configuration

    run do
      skip_if well_known_configuration.blank?, 'No well-known SMART configuration found.'

      assert_valid_json(well_known_configuration)
      capabilities = JSON.parse(well_known_configuration)['capabilities']
      assert capabilities.is_a?(Array),
             "Expected the well-known capabilities to be an Array, but found #{capabilities.class.name}"

      required_smart_capabilities = [
        'launch-standalone',
        'client-public',
        'client-confidential-symmetric',
        'sso-openid-connect',
        'context-standalone-patient',
        'permission-offline',
        'permission-patient'
      ]

      missing_capabilities = required_smart_capabilities - capabilities
      assert missing_capabilities.empty?,
             "The following capabilities required for this scenario are missing: #{missing_capabilities.join(', ')}"
    end
  end
end
