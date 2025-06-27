use emacs::{defun, Env, Result};

emacs::plugin_is_GPL_compatible!();

#[defun]
fn elevenshtein(_env: &Env) -> emacs::Result<String> {
    Ok("Hello from Rust!".to_string())
}

#[defun]
fn edit_distance(_env: &Env, source: String, target: String) -> emacs::Result<i32> {
    let cols: usize = source.chars().count();
    let rows: usize = target.chars().count();
    let mut _matrix = create_matrix(cols, rows);
    Ok(0)
}

// generate a 2D vector to store DP progress and final score
fn create_matrix(cols: usize, rows: usize) -> Vec<Vec<i32>> {
    let mut matrix: Vec<Vec<i32>> = vec![vec![0; cols]; rows];
    for n in 0..cols {
        matrix[0][n] = n as i32;
    }
    for n in 1..rows {
        matrix[n][0] = n as i32;
    }
    return matrix;
}

#[emacs::module(name = "elevenshtein")]
fn init(_: &Env) -> emacs::Result<()> {
    // one-time module initialisation goes here if you need it
    Ok(())
}

#[cfg(test)]
#[test]
fn test_matrix_creation() {
    //Validate that the correct vector representation of a matrix is created.
    assert_eq!(vec![vec![0, 1], vec![1, 0]], create_matrix(2, 2));
    assert_eq!(vec![vec![0]], create_matrix(1, 1));
    assert_eq!(Vec::<Vec::<i32>>::new(), create_matrix(0, 0));
}
