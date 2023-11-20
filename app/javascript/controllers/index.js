// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"
import HelloController from "./hello_controller.js"
import RemovalsController from "./removals_controller.js"


application.register("hello", HelloController)
application.register("removals", RemovalsController)