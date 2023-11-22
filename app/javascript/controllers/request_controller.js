import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="request"
export default class extends Controller {
  static values = { url: String }

  sendRequest(){
    post(this.urlValue, { responseKind: "turbo-stream" })
  }
}
