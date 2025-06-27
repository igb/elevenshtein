use emacs::{defun, Env, Result};

emacs::plugin_is_GPL_compatible!();

#[defun]
fn elevenshtein(env: &Env) -> emacs::Result<String> {
    Ok("Hello from Rust!".to_string())
}

#[defun]
fn edit_distance(env: &Env, source: String, target: String) -> emacs::Result<i64> {
    Ok(0)
}

#[emacs::module(name = "elevenshtein")]
fn init(_: &Env) -> emacs::Result<()> {
    // one-time module initialisation goes here if you need it
    Ok(())
}
