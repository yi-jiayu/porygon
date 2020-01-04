table! {
    events (id) {
        id -> Int4,
        timestamp -> Timestamptz,
        #[sql_name = "type"]
        type_ -> Text,
        user_id -> Int8,
        language_code -> Nullable<Text>,
        chat_id -> Nullable<Int8>,
        chat_type -> Nullable<Text>,
    }
}
