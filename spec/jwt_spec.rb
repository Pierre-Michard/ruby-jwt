# frozen_string_literal: true

RSpec.describe JWT do
  let(:payload) { { 'user_id' => 'some@user.tld' } }

  let :data do
   data = {
      :empty_token => 'e30K.e30K.e30K',
      :secret => 'My$ecretK3y',
      :rsa_private => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'rsa-2048-private.pem'))),
      :rsa_public => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'rsa-2048-public.pem'))),
      :wrong_rsa_private => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'rsa-2048-wrong-public.pem'))),
      :wrong_rsa_public => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'rsa-2048-wrong-public.pem'))),
      'ES256_private' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec256-private.pem'))),
      'ES256_public' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec256-public.pem'))),
      'ES384_private' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec384-private.pem'))),
      'ES384_public' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec384-public.pem'))),
      'ES512_private' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec512-private.pem'))),
      'ES512_public' => OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec512-public.pem'))),
      'NONE' => 'eyJhbGciOiJub25lIn0.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.',
      'HS256' => 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.kWOVtIOpWcG7JnyJG0qOkTDbOy636XrrQhMm_8JrRQ8',
      'HS512256' => 'eyJhbGciOiJIUzUxMjI1NiJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.Ds_4ibvf7z4QOBoKntEjDfthy3WJ-3rKMspTEcHE2bA',
      'HS384' => 'eyJhbGciOiJIUzM4NCJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.VuV4j4A1HKhWxCNzEcwc9qVF3frrEu-BRLzvYPkbWO0LENRGy5dOiBQ34remM3XH',
      'HS512' => 'eyJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.8zNtCBTJIZTHpZ-BkhR-6sZY1K85Nm5YCKqV3AxRdsBJDt_RR-REH2db4T3Y0uQwNknhrCnZGvhNHrvhDwV1kA',
      'RS256' => 'eyJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.eSXvWP4GViiwUALj_-qTxU68I1oM0XjgDsCZBBUri2Ghh9d75QkVDoZ_v872GaqunN5A5xcnBK0-cOq-CR6OwibgJWfOt69GNzw5RrOfQ2mz3QI3NYEq080nF69h8BeqkiaXhI24Q51joEgfa9aj5Y-oitLAmtDPYTm7vTcdGufd6AwD3_3jajKBwkh0LPSeMtbe_5EyS94nFoEF9OQuhJYjUmp7agsBVa8FFEjVw5jEgVqkvERSj5hSY4nEiCAomdVxIKBfykyi0d12cgjhI7mBFwWkPku8XIPGZ7N8vpiSLdM68BnUqIK5qR7NAhtvT7iyLFgOqhZNUQ6Ret5VpQ',
      'RS384' => 'eyJhbGciOiJSUzM4NCJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.Sfgk56moPghtsjaP4so6tOy3I553mgwX-5gByMC6dX8lpeWgsxSeAd_K8IyO7u4lwYOL0DSftnqO1HEOuN1AKyBbDvaTXz3u2xNA2x4NYLdW4AZA6ritbYcKLO5BHTXw5ueMbtA1jjGXP0zI_aK2iJTMBmB8SCF88RYBUH01Tyf4PlLj98pGL-v3prZd6kZkIeRJ3326h04hslcB5HQKmgeBk24QNLIoIC-CD329HPjJ7TtGx01lj-ehTBnwVbBGzYFAyoalV5KgvL_MDOfWPr1OYHnR5s_Fm6_3Vg4u6lBljvHOrmv4Nfx7d8HLgbo8CwH4qn1wm6VQCtuDd-uhRg',
      'RS512' => 'eyJhbGciOiJSUzUxMiJ9.eyJ1c2VyX2lkIjoic29tZUB1c2VyLnRsZCJ9.LIIAUEuCkGNdpYguOO5LoW4rZ7ED2POJrB0pmEAAchyTdIK4HKh1jcLxc6KyGwZv40njCgub3y72q6vcQTn7oD0zWFCVQRIDW1911Ii2hRNHuigiPUnrnZh1OQ6z65VZRU6GKs8omoBGU9vrClBU0ODqYE16KxYmE_0n4Xw2h3D_L1LF0IAOtDWKBRDa3QHwZRM9sHsHNsBuD5ye9KzDYN1YALXj64LBfA-DoCKfpVAm9NkRPOyzjR2X2C3TomOSJgqWIVHJucudKDDAZyEbO4RA5pI-UFYy1370p9bRajvtDyoBuLDCzoSkMyQ4L2DnLhx5CbWcnD7Cd3GUmnjjTA',
      'ES256' => '',
      'ES384' => '',
      'ES512' => '',
      'PS256' => '',
      'PS384' => '',
      'PS512' => ''
    }

    if defined?(RbNaCl)
      ed25519_private = RbNaCl::Signatures::Ed25519::SigningKey.new('abcdefghijklmnopqrstuvwxyzABCDEF')
      ed25519_public =  ed25519_private.verify_key
      data.merge!(
        'ED25519_private' =>  ed25519_private,
        'ED25519_public' => ed25519_public,
        'EdDSA_private' =>  ed25519_private,
        'EdDSA_public' => ed25519_public,
      )
    end
    data
  end

  after(:each) do
    expect(OpenSSL.errors).to be_empty
  end

  context 'alg: NONE' do
    let(:alg) { 'none' }
    let(:encoded_token) { data['NONE'] }

    it 'should generate a valid token' do
      token = JWT.encode payload, nil, alg

      expect(token).to eq encoded_token
    end

    context 'decoding without verification' do
      it 'should decode a valid token' do
        jwt_payload, header = JWT.decode encoded_token, nil, false

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end
    end

    context 'decoding with verification' do
      context 'without specifying the none algorithm' do
        it 'should fail to decode the token' do
          expect do
            JWT.decode encoded_token, nil, true
          end.to raise_error JWT::IncorrectAlgorithm
        end
      end

      context 'specifying the none algorithm' do
        context 'when the claims are valid' do
          it 'should decode the token' do
            jwt_payload, header = JWT.decode encoded_token, nil, true, { algorithms: 'none' }

            expect(header['alg']).to eq 'none'
            expect(jwt_payload).to eq payload
          end
        end

        context 'when the claims are invalid' do
          let(:encoded_token) { JWT.encode({ exp: 0 }, nil, 'none') }
          it 'should fail to decode the token' do
            expect do
              JWT.decode encoded_token, nil, true
            end.to raise_error JWT::DecodeError
          end
        end
      end
    end
  end

  context 'payload validation' do
    it 'validates the payload with the ClaimsValidator if the payload is a hash' do
      validator = double()
      expect(JWT::ClaimsValidator).to receive(:new) { validator }
      expect(validator).to receive(:validate!) { true }

      payload = {}
      JWT.encode payload, "secret", 'HS256'
    end

    it 'does not validate the payload if it is not present' do
      validator = double()
      expect(JWT::ClaimsValidator).not_to receive(:new) { validator }

      payload = nil
      JWT.encode payload, "secret", 'HS256'
    end
  end

  algorithms = %w[HS256 HS384 HS512]
  algorithms << 'HS512256' if defined?(RbNaCl)

  algorithms.each do |alg|
    context "alg: #{alg}" do
      it 'should generate a valid token' do
        token = JWT.encode payload, data[:secret], alg

        expect(token).to eq data[alg]
      end

      it 'should decode a valid token' do
        jwt_payload, header = JWT.decode data[alg], data[:secret], true, algorithm: alg

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end

      it 'wrong secret should raise JWT::DecodeError' do
        expect do
          JWT.decode data[alg], 'wrong_secret', true, algorithm: alg
        end.to raise_error JWT::VerificationError
      end

      it 'wrong secret and verify = false should not raise JWT::DecodeError' do
        expect do
          JWT.decode data[alg], 'wrong_secret', false
        end.not_to raise_error
      end
    end
  end

  %w[RS256 RS384 RS512].each do |alg|
    context "alg: #{alg}" do
      it 'should generate a valid token' do
        token = JWT.encode payload, data[:rsa_private], alg

        expect(token).to eq data[alg]
      end

      it 'should decode a valid token' do
        jwt_payload, header = JWT.decode data[alg], data[:rsa_public], true, algorithm: alg

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end

      it 'should decode a valid token using algorithm hash string key' do
        jwt_payload, header = JWT.decode data[alg], data[:rsa_public], true, 'algorithm' => alg

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end

      it 'wrong key should raise JWT::DecodeError' do
        key = OpenSSL::PKey.read File.read(File.join(CERT_PATH, 'rsa-2048-wrong-public.pem'))

        expect do
          JWT.decode data[alg], key, true, algorithm: alg
        end.to raise_error JWT::DecodeError
      end

      it 'wrong key and verify = false should not raise JWT::DecodeError' do
        key = OpenSSL::PKey.read File.read(File.join(CERT_PATH, 'rsa-2048-wrong-public.pem'))

        expect do
          JWT.decode data[alg], key, false
        end.not_to raise_error
      end
    end
  end

  if defined?(RbNaCl)
    %w[ED25519 EdDSA].each do |alg|
      context "alg: #{alg}" do
        before(:each) do
          data[alg] = JWT.encode payload, data["#{alg}_private"], alg
        end

        let(:wrong_key) { OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec256-wrong-public.pem'))) }

        it 'should generate a valid token' do
          jwt_payload, header = JWT.decode data[alg], data["#{alg}_public"], true, algorithm: alg

          expect(header['alg']).to eq alg
          expect(jwt_payload).to eq payload
        end

        it 'should decode a valid token' do
          jwt_payload, header = JWT.decode data[alg], data["#{alg}_public"], true, algorithm: alg

          expect(header['alg']).to eq alg
          expect(jwt_payload).to eq payload
        end

        it 'wrong key should raise JWT::DecodeError' do
          expect do
            JWT.decode data[alg], wrong_key
          end.to raise_error JWT::DecodeError
        end

        it 'wrong key and verify = false should not raise JWT::DecodeError' do
          expect do
            JWT.decode data[alg], wrong_key, false
          end.not_to raise_error
        end
      end
    end
  end

  %w[ES256 ES384 ES512].each do |alg|
    context "alg: #{alg}" do
      before(:each) do
        data[alg] = JWT.encode payload, data["#{alg}_private"], alg
      end

      let(:wrong_key) { OpenSSL::PKey.read(File.read(File.join(CERT_PATH, 'ec256-wrong-public.pem'))) }

      it 'should generate a valid token' do
        jwt_payload, header = JWT.decode data[alg], data["#{alg}_public"], true, algorithm: alg

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end

      it 'should decode a valid token' do
        jwt_payload, header = JWT.decode data[alg], data["#{alg}_public"], true, algorithm: alg

        expect(header['alg']).to eq alg
        expect(jwt_payload).to eq payload
      end

      it 'wrong key should raise JWT::DecodeError' do
        expect do
          JWT.decode data[alg], wrong_key
        end.to raise_error JWT::DecodeError
      end

      it 'wrong key and verify = false should not raise JWT::DecodeError' do
        expect do
          JWT.decode data[alg], wrong_key, false
        end.not_to raise_error
      end
    end
  end

  unless ::Gem::Version.new(OpenSSL::VERSION) >= ::Gem::Version.new('2.1')
    %w[PS256 PS384 PS512].each do |alg|
      context "alg: #{alg}" do
        it 'raises error about OpenSSL version' do
          expect { JWT.encode payload, data[:rsa_private], alg }.to raise_error(
            JWT::RequiredDependencyError,
            /You currently have OpenSSL .*. PS support requires >= 2.1/
          )
        end
      end
    end
  else
    %w[PS256 PS384 PS512].each do |alg|
      context "alg: #{alg}" do
        before(:each) do
          data[alg] = JWT.encode payload, data[:rsa_private], alg
        end

        let(:wrong_key) { data[:wrong_rsa_public] }

        it 'should generate a valid token' do
          token = data[alg]

          header, body, signature = token.split('.')

          expect(header).to eql(Base64.strict_encode64({ alg: alg }.to_json))
          expect(body).to   eql(Base64.strict_encode64(payload.to_json))

          # Validate signature is made of up header and body of JWT
          translated_alg  = alg.gsub('PS', 'sha')
          valid_signature = data[:rsa_public].verify_pss(
            translated_alg,
            JWT::Base64.url_decode(signature),
            [header, body].join('.'),
            salt_length: :auto,
            mgf1_hash:   translated_alg
          )
          expect(valid_signature).to be true
        end

        it 'should decode a valid token' do
          jwt_payload, header = JWT.decode data[alg], data[:rsa_public], true, algorithm: alg

          expect(header['alg']).to eq alg
          expect(jwt_payload).to eq payload
        end

        it 'wrong key should raise JWT::DecodeError' do
          expect do
            JWT.decode data[alg], wrong_key
          end.to raise_error JWT::DecodeError
        end

        it 'wrong key and verify = false should not raise JWT::DecodeError' do
          expect do
            JWT.decode data[alg], wrong_key, false
          end.not_to raise_error
        end
      end
    end
  end

  context 'Invalid' do
    it 'algorithm should raise NotImplementedError' do
      expect do
        JWT.encode payload, 'secret', 'HS255'
      end.to raise_error NotImplementedError
    end

    it 'raises "No verification key available" error' do
      token = JWT.encode({}, 'foo')
      expect { JWT.decode(token, nil, true) }.to raise_error(JWT::DecodeError, 'No verification key available')
    end

    it 'ECDSA curve_name should raise JWT::IncorrectAlgorithm' do
      key = OpenSSL::PKey::EC.new 'secp256k1'
      key.generate_key

      expect do
        JWT.encode payload, key, 'ES256'
      end.to raise_error JWT::IncorrectAlgorithm

      token = JWT.encode payload, data['ES256_private'], 'ES256'
      key.private_key = nil

      expect do
        JWT.decode token, key
      end.to raise_error JWT::IncorrectAlgorithm
    end
  end

  context 'Verify' do
    context 'algorithm' do
      it 'should raise JWT::IncorrectAlgorithm on mismatch' do
        token = JWT.encode payload, data[:secret], 'HS256'

        expect do
          JWT.decode token, data[:secret], true, algorithm: 'HS384'
        end.to raise_error JWT::IncorrectAlgorithm

        expect do
          JWT.decode token, data[:secret], true, algorithm: 'HS256'
        end.not_to raise_error
      end

      it 'should raise JWT::IncorrectAlgorithm on mismatch prior to kid public key network call' do
        token = JWT.encode payload, data[:rsa_private], 'RS256'

        expect do
          JWT.decode(token, nil, true, { algorithms: ['RS384'] }) do |_,_|
            # unsuccessful keyfinder public key network call here
          end
        end.to raise_error JWT::IncorrectAlgorithm

        expect do
          JWT.decode(token, nil, true, { 'algorithms' => ['RS384'] }) do |_,_|
            # unsuccessful keyfinder public key network call here
          end
        end.to raise_error JWT::IncorrectAlgorithm
      end

      it 'should raise JWT::IncorrectAlgorithm when algorithms array does not contain algorithm' do
        token = JWT.encode payload, data[:secret], 'HS512'

        expect do
          JWT.decode token, data[:secret], true, algorithms: ['HS384']
        end.to raise_error JWT::IncorrectAlgorithm

        expect do
          JWT.decode token, data[:secret], true, 'algorithms' => ['HS384']
        end.to raise_error JWT::IncorrectAlgorithm

        expect do
          JWT.decode token, data[:secret], true, algorithms: ['HS512', 'HS384']
        end.not_to raise_error

        expect do
          JWT.decode token, data[:secret], true, 'algorithms' => ['HS512', 'HS384']
        end.not_to raise_error
      end

      context 'no algorithm provided' do
        it 'should use the default decode algorithm' do
          token = JWT.encode payload, data[:rsa_public].to_s

          jwt_payload, header = JWT.decode token, data[:rsa_public].to_s

          expect(header['alg']).to eq 'HS256'
          expect(jwt_payload).to eq payload
        end
      end

      context 'token is missing algorithm' do
        it 'should raise JWT::IncorrectAlgorithm' do
          expect do
            JWT.decode data[:empty_token]
          end.to raise_error JWT::IncorrectAlgorithm
        end
      end
    end

    context 'issuer claim' do
      let(:iss) { 'ruby-jwt-gem' }
      let(:invalid_token) { JWT.encode payload, data[:secret] }

      let :token do
        iss_payload = payload.merge(iss: iss)
        JWT.encode iss_payload, data[:secret]
      end
      it 'if verify_iss is set to false (default option) should not raise JWT::InvalidIssuerError' do
        expect do
          JWT.decode token, data[:secret], true, iss: iss, algorithm: 'HS256'
        end.not_to raise_error
      end
    end
  end

  context 'a token with no segments' do
    it 'raises JWT::DecodeError' do
      expect { JWT.decode('ThisIsNotAValidJWTToken', nil, true) }.to raise_error(JWT::DecodeError, 'Not enough or too many segments')
    end
  end

  context 'a token with not enough segments' do
    it 'raises JWT::DecodeError' do
      token = JWT.encode('ThisIsNotAValidJWTToken', 'secret').split('.').slice(1,2).join
      expect { JWT.decode(token, nil, true) }.to raise_error(JWT::DecodeError, 'Not enough or too many segments')
    end
  end

  context 'a token with not too many segments' do
    it 'raises JWT::DecodeError' do
      expect { JWT.decode('ThisIsNotAValidJWTToken.second.third.signature', nil, true) }.to raise_error(JWT::DecodeError, 'Not enough or too many segments')
    end
  end

  context 'a token with two segments but does not require verifying' do
    it 'raises something else than "Not enough or too many segments"' do
      expect { JWT.decode('ThisIsNotAValidJWTToken.second', nil, false) }.to raise_error(JWT::DecodeError, 'Invalid segment encoding')
    end
  end

  context 'Base64' do
    it 'urlsafe replace + / with - _' do
      allow(Base64).to receive(:encode64) { 'string+with/non+url-safe/characters_' }
      expect(JWT::Base64.url_encode('foo')).to eq('string-with_non-url-safe_characters_')
    end
  end

  it 'should not verify token even if the payload has claims' do
    head = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9'
    load = 'eyJ1c2VyX2lkIjo1NCwiZXhwIjoxNTA0MzkwODA0fQ'
    sign = 'Skpi6FfYMbZ-DwW9ocyRIosNMdPMAIWRLYxRO68GTQk'

    expect do
      JWT.decode([head, load, sign].join('.'), '', false)
    end.not_to raise_error
  end

  it 'should not raise InvalidPayload exception if payload is an array' do
    expect do
      JWT.encode(['my', 'payload'], 'secret')
    end.not_to raise_error
  end

  it 'should encode string payloads' do
    expect do
      JWT.encode 'Hello World', 'secret'
    end.not_to raise_error
  end

  context 'when the alg value is given as a header parameter' do

    it 'does not override the actual algorithm used' do
      headers = JSON.parse(::JWT::Base64.url_decode(JWT.encode('Hello World', 'secret', 'HS256', { alg: 'HS123'}).split('.').first))
      expect(headers['alg']).to eq('HS256')
    end

    it "should generate the same token" do
      expect(JWT.encode('Hello World', 'secret', 'HS256', { alg: 'HS256'})).to eq JWT.encode('Hello World', 'secret', 'HS256')
    end
  end

  context 'when hmac algorithm is used without secret key' do
    it 'encodes payload' do
      payload = { a: 1, b: 'b'}

      token = JWT.encode(payload, '', 'HS256')

      expect do
        token_without_secret = JWT.encode(payload, nil, 'HS256')
        expect(token).to eq(token_without_secret)
      end.not_to raise_error
    end
  end

  context 'algorithm case insensitivity' do
    let(:payload) { { 'a' => 1, 'b' => 'b' } }

    it 'ignores algorithm casing during encode/decode' do
      enc = JWT.encode(payload, '', 'hs256')
      expect(JWT.decode(enc, '')).to eq([payload, { 'alg' => 'HS256'}])

      enc = JWT.encode(payload, data[:rsa_private], 'rs512')
      expect(JWT.decode(enc, data[:rsa_public], true, algorithm: 'RS512')).to eq([payload, { 'alg' => 'RS512'}])

      enc = JWT.encode(payload, data[:rsa_private], 'RS512')
      expect(JWT.decode(enc, data[:rsa_public], true, algorithm: 'rs512')).to eq([payload, { 'alg' => 'RS512'}])
    end

    it 'raises error for invalid algorithm' do
      expect do
        JWT.encode(payload, '', 'xyz')
      end.to raise_error(NotImplementedError)
    end
  end

  describe '::JWT.decode with verify_iat parameter' do
    let!(:time_now) { Time.now }
    let(:token)     { ::JWT.encode({ pay: 'load', iat: iat}, 'secret', 'HS256') }

    subject(:decoded_token) { ::JWT.decode(token, 'secret', true, verify_iat: true) }

    before { allow(Time).to receive(:now) { time_now } }

    context 'when iat is exactly the same as Time.now and iat is given as a float' do
      let(:iat) { time_now.to_f }
      it 'considers iat valid' do
        expect(decoded_token).to be_an(Array)
      end
    end

    context 'when iat is exactly the same as Time.now and iat is given as floored integer' do
      let(:iat) { time_now.to_f.floor }
      it 'considers iat valid' do
        expect(decoded_token).to be_an(Array)
      end
    end

    context 'when iat is 1 second before Time.now' do
      let(:iat) { time_now.to_i + 1 }
      it 'raises an error' do
        expect { decoded_token }.to raise_error(::JWT::InvalidIatError, 'Invalid iat')
      end
    end
  end
end
