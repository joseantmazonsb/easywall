"""TODO: Doku."""
from typing import Any

from tests import unittest
from tests.utils import (prepare_client, prepare_configuration,
                         restore_configuration)
from tests.web.test_login import TestLogin

from easywall.utility import delete_file_if_exists


class TestApply(unittest.TestCase):
    """TODO: Doku."""

    def setUp(self) -> None:
        """TODO: Doku."""
        prepare_configuration()
        self.client = prepare_client()
        self.login = TestLogin()

    def tearDown(self) -> None:
        """TODO: Doku."""
        restore_configuration()
        delete_file_if_exists(".apply")
        delete_file_if_exists(".acceptance")

    def test_apply_logged_out(self) -> None:
        """TODO: Doku."""
        response = self.client.get('/apply')
        self.assertIn(b"Please log in", response.data)

    def test_apply_logged_in(self) -> None:
        """TODO: Doku."""
        self.login.log_in(self.client)
        self.client.get('/apply')

    def test_apply_save_step_1(self) -> Any:
        """TODO: Doku."""
        self.login.log_in(self.client)
        return self.client.post('/apply-save', data=dict(
            step_1=""
        ), follow_redirects=True)

    def test_apply_save_step_2(self) -> Any:
        """TODO: Doku."""
        self.login.log_in(self.client)
        return self.client.post('/apply-save', data=dict(
            step_2=""
        ), follow_redirects=True)

    def test_apply_save_logged_out(self) -> None:
        """TODO: Doku."""
        response = self.client.post('/apply-save')
        self.assertIn(b"Please log in", response.data)
