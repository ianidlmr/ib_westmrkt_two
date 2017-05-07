# frozen_string_literal: true
Stripe.api_key = Figaro.env.stripe_api_key
