#pragma once

#include "zxpch.h"

#include "Core/Macro.h"

namespace ZeXo
{
	enum class EventType
	{
		KeyPressed,
		KeyReleased,

		MouseMoved,
		MouseButtonPressed,
		MouseButtonReleased,
		MouseWheelScrolled, 

		WindowResized,
		WindowClosed,

		AppTick,
		AppRender,

		// Add more events;
	};

	class ZX_API Event
	{
	protected:
		bool m_Handled = false;

		friend class EventDispatcher;

	public:
		virtual ~Event() {}

		virtual EventType	GetEventType()		const = 0;
		virtual const char* GetEventName()		const = 0;
		virtual std::string GetEventNameStr()   const = 0;
		virtual std::string GetEventInfo()		const = 0;

		virtual bool IsHandled() const = 0;
	};

	class EventDispatcher
	{
	private:
		template <typename T>
		using EventFunction = std::function<bool(T&)>;

		Event& m_Event;
	public:
		EventDispatcher(Event& e) : m_Event(e) {}

		template <typename T>
		bool Emit(EventFunction<T> function)
		{
			if (m_Event.GetEventType() == T::GetEventStaticType())
			{
				m_Event.m_Handled = function(*(T*)&m_Event);
				return true;
			}

			return false;
		}
	};

	#define ZX_BIND_FUNCTION(fn) std::bind(fn, std::placeholders::_1)
	#define ZX_BIND_MEMBER_FUNCTION(owner, fn) std::bind(fn, owner, std::placeholders::_1)
}