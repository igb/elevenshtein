use emacs::{defun, Env};
use std::fs;

emacs::plugin_is_GPL_compatible!();

#[defun]
fn edit_distance(_env: &Env, source: String, target: String) -> emacs::Result<i32> {
    //calculate edit distance
    return Ok(edit_distance_impl(&source, &target));
}

fn edit_distance_impl(source: &str, target: &str) -> i32 {
    let cols: usize = source.chars().count();
    let rows: usize = target.chars().count();
    let mut matrix = create_matrix(cols, rows);
    for i in 1..(rows + 1) {
        for j in 1..(cols + 1) {
            let source_c = source.chars().nth(j - 1).unwrap();
            let target_c = target.chars().nth(i - 1).unwrap();

            let cost: i32 = if source_c == target_c { 0 } else { 1 };

            let deletion = matrix[i - 1][j] + 1;
            let insertion = matrix[i][j - 1] + 1;
            let substitution = matrix[i - 1][j - 1] + cost;

            matrix[i][j] = vec![deletion, insertion, substitution]
                .iter()
                .cloned()
                .min()
                .expect("WTF!");
        }
    }
    return matrix[rows][cols];
}

// generate a 2D vector to store DP progress and final score
fn create_matrix(cols: usize, rows: usize) -> Vec<Vec<i32>> {
    let mut matrix: Vec<Vec<i32>> = vec![vec![0; cols + 1]; rows + 1];
    for n in 1..cols + 1 {
        matrix[0][n] = n as i32;
    }
    for n in 1..rows + 1 {
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
fn test_n_distance(n: i32) {
    assert_eq!(
        n,
        edit_distance_impl(
            &fs::read_to_string(format!("../tests/resources/x-{}.txt", n)).unwrap(),
            &fs::read_to_string(format!("../tests/resources/y-{}.txt", n)).unwrap()
        )
    )
}

#[test]
fn test_matrix_creation() {
    //Validate that the correct vector representation of a matrix is created.
    assert_eq!(
        vec![vec![0, 1, 2], vec![1, 0, 0], vec![2, 0, 0]],
        create_matrix(2, 2)
    );
    assert_eq!(vec![vec![0, 1], vec![1, 0]], create_matrix(1, 1));
    assert_eq!(vec![vec![0]], create_matrix(0, 0));
    assert_eq!(
        vec![
            vec![0, 1, 2, 3, 4, 5],
            vec![1, 0, 0, 0, 0, 0],
            vec![2, 0, 0, 0, 0, 0],
            vec![3, 0, 0, 0, 0, 0],
            vec![4, 0, 0, 0, 0, 0],
            vec![5, 0, 0, 0, 0, 0]
        ],
        create_matrix(5, 5)
    );
    assert_eq!(
        vec![
            vec![0, 1, 2, 3],
            vec![1, 0, 0, 0],
            vec![2, 0, 0, 0],
            vec![3, 0, 0, 0],
            vec![4, 0, 0, 0]
        ],
        create_matrix("one".chars().count(), "four".chars().count())
    );
}

#[test]
fn test_edit_distance_same() {
    // Validate that two identical strings have an edit distance of '0'.

    assert_eq!(
        0,
        edit_distance_impl("This should be the same.", "This should be the same.")
    );
}

#[test]
fn test_edit_distance_basic() {
    // Basic edit distance calculation.

    assert_eq!(3, edit_distance_impl("kitten", "sitting"));
}

#[test]
fn test_edit_distance_different_lengths() {
    // Ensure that edit distance is calculated correctly when strings are of different lengths.

    assert_eq!(
        22,
        edit_distance_impl(
            "This is a short string.",
            "This is a much, much, much, longer string."
        )
    );
}

#[test]
fn test_edit_distance_different_lengths_different_order() {
    // Ensure that edit distance is calculated correctly when strings are of different lengths and are compared in a different order.

    assert_eq!(
        22,
        edit_distance_impl(
            "This is a much, much, much, longer string.",
            "This is a short string."
        )
    );
}

#[test]
fn test_edit_distance_100() {
    //   Ensure that edit distance is calculated correctly with max delta for a 100-byte string.
    test_n_distance(100);
}

#[test]
fn test_edit_distance_1000() {
    //   Ensure that edit distance is calculated correctly with max delta for a 1000-byte string.
    test_n_distance(1000);
}

#[test]
fn test_edit_distance_10000() {
    //   Ensure that edit distance is calculated correctly with max delta for a 10000-byte string.
    test_n_distance(10000);
}
