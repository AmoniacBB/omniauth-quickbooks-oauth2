# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::QuickbooksOauth2 do
  let(:request) do
    instance_double(Rack::Request,
                    params: { 'realmId' => 123 },
                      cookies: {},
                      env: {})
  end
  let(:app) do
    lambda do
      [200, {}, ['Hello.']]
    end
  end
  let(:strategy) do
    described_class.new(app, 'abc', 'def', options).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  let(:client) { OAuth2::Client.new('abc', 'def') }
  let(:params) { nil }
  let(:access_token) do
    OAuth2::AccessToken.from_hash(
      client,
      access_token: 'valid_access_token',
      expires_at: 1_664_296_361,
      refresh_token: 'valid_refresh_token'
    )
  end
  let(:parsed_response) { instance_double(OAuth2::Response) }
  let(:response) { instance_double(OAuth2::Response, parsed: parsed_response) }

  let(:options) { {} }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it 'has a version number' do
    expect(OmniAuth::QuickbooksOauth2::VERSION).not_to be_nil
  end

  describe '#client' do
    it 'has the correct name' do
      expect(strategy.options.name).to eq(:quickbooks_oauth2)
    end

    it 'has the correct site' do
      expect(strategy.client.site).to eq('https://appcenter.intuit.com/connect/oauth2')
    end

    it 'has the correct authorize url' do
      expect(strategy.client.authorize_url).to eq('https://appcenter.intuit.com/connect/oauth2')
    end

    it 'has the correct token url' do
      expect(strategy.client.token_url).to eq('https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer')
    end
  end

  describe '#authorize_params' do
    it 'passes account_id from request params' do
      options['scope'] = 'com.intuit.quickbooks.accounting openid'
      expect(strategy.authorize_params[:scope]).to eq 'com.intuit.quickbooks.accounting openid'
    end
  end

  describe '#access_token' do
    before do
      allow(strategy).to receive(:access_token) { access_token }
      allow(access_token).to receive(:params) { params }
    end

    it 'return access token and refresh token' do
      expect(strategy.credentials)
        .to match({
                    'token' => 'valid_access_token', 'refresh_token' => 'valid_refresh_token',
                    'expires' => true, 'expires_at' => 1_664_296_361
                  })
    end
  end

  describe '#callback_url' do
    context 'when not include in query parameters' do
      it 'is nil' do
        expect(strategy.authorize_params['redirect_uri']).to be_nil
      end
    end

    context 'when include in query parameters' do
      let(:options) { { redirect_uri: 'http://example.com/callback' } }

      it 'is string' do
        expect(strategy.callback_url).to eq 'http://example.com/callback'
      end
    end
  end

  describe '#raw_info, #info, #extra' do
    let(:response) do
      instance_double(OAuth2::Response, body: { 'email' => 'testemail', 'id' => 123 }.to_json)
    end
    let(:options) { { scope: 'com.intuit.quickbooks.accounting openid' } }

    before do
      allow(strategy).to receive(:access_token) { access_token }
      allow(access_token).to receive(:params) { params }
    end

    it "calls to '/userinfo'" do
      allow(access_token).to receive(:get)
        .with('https://sandbox-accounts.platform.intuit.com/v1/openid_connect/userinfo')
        .and_return(response)
      expect(strategy.raw_info).to eq('email' => 'testemail', 'id' => 123)
    end

    context 'when no openid' do
      let(:options) { { scope: 'com.intuit.quickbooks.accounting' } }

      it 'return {}' do
        expect(strategy.raw_info).to eq({})
      end
    end

    it 'uid must be integer' do
      expect(strategy.uid).to eq request.params['realmId']
    end
  end

  describe '#info, #extra' do
    before do
      allow(strategy).to receive(:raw_info).and_return({})
    end

    it 'delegates to raw_info' do
      expect(strategy.info).to eq strategy.raw_info
    end

    it 'delegates to raw_info{}' do
      expect(strategy.extra).to eq({ raw_info: strategy.raw_info })
    end
  end
end
