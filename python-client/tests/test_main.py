"""Tests for main module."""

import pytest
from src.main import hello


def test_hello_default():
    """Test hello function with default parameter."""
    result = hello()
    assert result == "Hello, World!"


def test_hello_with_name():
    """Test hello function with custom name."""
    result = hello("Alice")
    assert result == "Hello, Alice!"


@pytest.mark.parametrize("name,expected", [
    ("Bob", "Hello, Bob!"),
    ("Charlie", "Hello, Charlie!"),
    ("", "Hello, !"),
])
def test_hello_parametrized(name, expected):
    """Test hello function with various inputs."""
    result = hello(name)
    assert result == expected
