""""

This file is part of the project manager.
File: resource.py
Purpose: The entry point for the project.
Author: Alisoft
Date: 2026-09-03
Version: 1.0.0
License: MIT License

"""

from __future__ import annotations
from abc import ABC, abstractmethod
from ast import Name
from enum import StrEnum

class ResourceType(StrEnum):
    """
    Enum class for the resource type
    """
    CONSUMABLE = "Consumable"
    USABLE = "Usable"

class Resource(ABC):
    """
    Abstract class for the resource type
    """

    __slots__ = ("_name", "_is_available", "_resource_type")
    def __init__(self, name: str, resource_type: ResourceType):
        """
        Initializer for the Resource class
        Args:
            :param name:
            :param resource_type:
        """
        self._name = name
        self._is_available = True
        self._resource_type = resource_type

    @property
    def name(self) -> str:
        """
        Getter for the name
        :returns:
            The name of the resource
        """
        return self._name
    @property
    def is_available(self) -> bool:
        """
        Getter for the is_available
        :returns:
            bool: True if the resource is available, False otherwise
        """
        return self._is_available

    @property
    def resource_type(self) -> ResourceType:

        """
        Getter for the resource_type
        :returns:
            The type of the resource
        """

        return self._resource_type

    @abstractmethod
    def allocate(self) -> None:
        """
        Allocate the resource
        :return:
        """
        pass
    @abstractmethod
    def release(self) -> None:
        """
        Release the resource
        :return:
        """
        pass
    @abstractmethod
    def use(self) -> None:
        """
        Use the resource
        :return:
        """
        pass