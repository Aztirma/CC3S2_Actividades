// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import 'jquery';
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

Rails.start();
ActiveStorage.start();
