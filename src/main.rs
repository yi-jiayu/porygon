#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

use rocket_contrib::json::Json;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Event {
    chat_id: i64,
    user_id: i64,
}

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[post("/", format = "json", data = "<event>")]
fn new_event(event: Json<Event>) -> Json<Event> {
    return event;
}

fn main() {
    rocket::ignite()
        .mount("/", routes![index])
        .mount("/events", routes![new_event])
        .launch();
}
