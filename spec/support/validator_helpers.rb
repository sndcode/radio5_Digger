# frozen_string_literal: true

module ValidatorHelpers
  module_function

  def expect_validation(method, *args)
    expect_any_instance_of(Radio5::Validator)
      .to receive(method)
      .with(*args)
      .exactly(1)
  end

  def expect_track_id_validation(track_id)
    expect_validation(:validate_track_id!, track_id)
  end

  def expect_island_id_validation(island_id)
    expect_validation(:validate_island_id!, island_id)
  end

  def expect_user_id_validation(user_id)
    expect_validation(:validate_user_id!, user_id)
  end

  def expect_user_track_status_validation(status)
    expect_validation(:validate_user_track_status!, status)
  end

  def expect_page_size_validation(size)
    expect_validation(:validate_page_size!, size)
  end

  def expect_page_number_validation(page)
    expect_validation(:validate_page_number!, page)
  end

  def expect_country_iso_codes_validation(iso_codes)
    expect_validation(:validate_country_iso_codes!, iso_codes)
  end

  def expect_country_iso_code_validation(iso_code)
    expect_validation(:validate_country_iso_code!, iso_code)
  end

  def expect_decades_validation(decades)
    expect_validation(:validate_decades!, decades)
  end

  def expect_decade_validation(decade)
    expect_validation(:validate_decade!, decade)
  end

  def expect_moods_validation(moods)
    expect_validation(:validate_moods!, moods)
  end
end
