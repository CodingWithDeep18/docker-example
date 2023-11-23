// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"
import RequestController from "./request_controller.js"
import HelloController from "./hello_controller.js"

application.register("hello", HelloController)
application.register("request", RequestController)