using System;
using System.Collections.Generic;

namespace Hsp.Novels.Common
{
    /// <summary>
    /// 多线程下的单例模式
    /// </summary>
    public class Singleton
    {
        private static readonly IDictionary<Type, object> _allSingletons;

        static Singleton()
        {
            _allSingletons = new Dictionary<Type, object>();
        }

        /// <summary>
        ///     字典类型Singl
        /// </summary>
        public static IDictionary<Type, object> AllSingletons
        {
            get { return _allSingletons; }
        }
    }

    public class Singleton<T> : Singleton
    {
        private static T _instance;

        /// <summary>
        ///     指定类型的单例
        ///     T 只有一个实例
        /// </summary>
        public static T Instance
        {
            get { return _instance; }

            set
            {
                _instance = value;
                AllSingletons[typeof (T)] = value;
            }
        }
    }


    public class SingletonList<T> : Singleton<IList<T>>
    {
        static SingletonList()
        {
            Singleton<IList<T>>.Instance = new List<T>();
        }

        /// <summary>
        ///     单例集合 对象集合只有一个实例
        /// </summary>
        public new static IList<T> Instance
        {
            get { return Singleton<IList<T>>.Instance; }
        }

        /// <summary>
        ///     单例字典
        /// </summary>
        /// <typeparam name="TKey"></typeparam>
        /// <typeparam name="TValue"></typeparam>
        public class SingletonDictionary<TKey, TValue> : Singleton<IDictionary<TKey, TValue>>
        {
            static SingletonDictionary()
            {
                Singleton<Dictionary<TKey, TValue>>.Instance = new Dictionary<TKey, TValue>();
            }
        }
    }
}