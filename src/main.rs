#![feature(proc_macro_hygiene, decl_macro)]

pub mod schema;

#[macro_use]
extern crate rocket;

#[macro_use]
extern crate rocket_contrib;

#[macro_use]
extern crate diesel;

use chrono::{DateTime, Utc};
use diesel::result::Error;
use diesel::RunQueryDsl;
use rocket::http::Status;
use rocket_contrib::json::Json;
use schema::events;
use serde::{Deserialize, Serialize};

#[database("porygon")]
struct MyDatabase(diesel::PgConnection);

#[derive(Serialize, Deserialize, Insertable)]
#[table_name = "events"]
struct Event {
    timestamp: DateTime<Utc>,
    #[serde(rename = "type")]
    type_: String,
    user_id: i64,
    chat_id: i64,
    chat_type: String,
}

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[post("/", format = "json", data = "<event>")]
fn new_event(event: Json<Event>, conn: MyDatabase) -> Result<Status, Error> {
    let event = event.into_inner();
    diesel::insert_into(schema::events::table)
        .values(&event)
        .execute(&*conn)?;
    return Ok(Status::NoContent);
}

fn main() {
    // Configure Rocket to listen on the port specified by $PORT without using rocket::custom().
    use std::env;
    let port = env::var("PORT").unwrap_or("8080".to_owned());
    env::set_var("ROCKET_PORT", port);

    rocket::ignite()
        .mount("/", routes![index])
        .mount("/events", routes![new_event])
        .attach(MyDatabase::fairing())
        .launch();
}
