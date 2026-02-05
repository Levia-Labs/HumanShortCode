import unittest

from python.human_short_code.__main__ import ID_CODE_LENGTH, decode, encode


class CodeIdTest(unittest.TestCase):
    def verify_number(self, number):
        # Encode the number
        id_string = encode(number)

        # verify encoding
        # 6 characters + 1 hyphen
        self.assertEqual(len(id_string), ID_CODE_LENGTH + 1)
        self.assertIn("-", id_string)

        # Decode the encoded string
        id_number = decode(id_string)

        # Ensure that decoding returns the original number
        self.assertEqual(number, id_number)

    def test_encode_decode(self):
        # Test with a range of numbers to ensure consistency
        for number in range(1, 10):
            self.verify_number(number)

        for number in range(490, 500):
            self.verify_number(number)

        for number in range(990, 1010):
            self.verify_number(number)

        for number in range(9990, 10010):
            self.verify_number(number)

        for number in range(99990, 100010):
            self.verify_number(number)

        for number in range(999990, 1000010):
            self.verify_number(number)

        for number in range(9999990, 10000010):
            self.verify_number(number)

        for number in range(99999990, 100000010):
            self.verify_number(number)
