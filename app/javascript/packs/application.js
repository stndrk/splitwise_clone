// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import jQuery from 'jquery';
window.$ = jQuery
window.jQuery = jQuery

import 'bootstrap/dist/js/bootstrap'
import "bootstrap"
import "../stylesheets/application"

require("jgrowl")
Rails.start()
Turbolinks.start()
ActiveStorage.start()



document.addEventListener("turbo:load", function() {
  var toggle = document.getElementById("accountDropdown");
  var menu = document.getElementById("accountMenu");
  if (!toggle || !menu) return;

  toggle.addEventListener("click", function(e) {
    e.preventDefault();
    menu.classList.toggle("show");
  });

  document.addEventListener("click", function(e) {
    if (!toggle.contains(e.target) && !menu.contains(e.target)) {
      menu.classList.remove("show");
    }
  });
});
